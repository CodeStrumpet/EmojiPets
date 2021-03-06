#include "pebble_os.h"
#include "pebble_app.h"
#include "pebble_fonts.h"
#include "resource_ids.auto.h"
#include <stdint.h>
#include <string.h>

#define BITMAP_BUFFER_BYTES 1024

#define MY_UUID { 0xB2, 0xF9, 0xE6, 0x12, 0x68, 0x71, 0x45, 0x1C, 0xB2, 0x3B, 0x2C, 0x93, 0x32, 0xCD, 0x51, 0x27 }
PBL_APP_INFO(MY_UUID,
             "EmojiPet", "CodeStrumpet",
             1, 0, /* App version */
             DEFAULT_MENU_ICON,
             APP_INFO_STANDARD_APP);

static struct EmojiPetData {
  Window window;
  BitmapLayer icon_layer;
  uint32_t current_icon;
  HeapBitmap icon_bitmap;
  AppSync sync;
  uint8_t sync_buffer[32];
} s_data;

enum {
  EMOJIPET_ICON_KEY = 0x0,         // TUPLE_INT
};

static uint32_t EMOJI_ARRAY[] = {
    RESOURCE_ID_IMAGE_SET0_BORED_0,
    RESOURCE_ID_IMAGE_SET0_BORED_1,
    RESOURCE_ID_IMAGE_SET0_HAPPY_0,
    RESOURCE_ID_IMAGE_SET0_HAPPY_1,
    RESOURCE_ID_IMAGE_SET0_HUNGRY_0,
    RESOURCE_ID_IMAGE_SET0_INTRIGUED_0,
    RESOURCE_ID_IMAGE_SET0_INTRIGUED_1,
    RESOURCE_ID_IMAGE_SET0_WORRIED_0,
    RESOURCE_ID_IMAGE_SET0_WORRIED_1,
    RESOURCE_ID_IMAGE_SET0_WILDCARD_2,
    RESOURCE_ID_IMAGE_SET0_WILDCARD_3,
    RESOURCE_ID_IMAGE_SET1_BORED_0,
    RESOURCE_ID_IMAGE_SET1_BORED_1,
    RESOURCE_ID_IMAGE_SET1_BORED_2,
    RESOURCE_ID_IMAGE_SET1_BORED_3,
    RESOURCE_ID_IMAGE_SET1_HAPPY_0,
    RESOURCE_ID_IMAGE_SET1_HAPPY_1,
    RESOURCE_ID_IMAGE_SET1_HAPPY_3,
    RESOURCE_ID_IMAGE_SET1_HUNGRY_0,
    RESOURCE_ID_IMAGE_SET1_INTRIGUED_0,
    RESOURCE_ID_IMAGE_SET1_INTRIGUED_1,
    RESOURCE_ID_IMAGE_SET1_INTRIGUED_2, // HAPPY_2 deduped into this one
    RESOURCE_ID_IMAGE_SET1_INTRIGUED_3,
    RESOURCE_ID_IMAGE_SET1_WORRIED_0,
    RESOURCE_ID_IMAGE_SET1_WORRIED_1,
    RESOURCE_ID_IMAGE_SET1_WORRIED_2,
    RESOURCE_ID_IMAGE_SET1_WORRIED_3,
};

static void load_bitmap(uint32_t resource_id) {
  // If that resource is already the current icon, we don't need to reload it
  if (s_data.current_icon == resource_id) {
    return;
  }
  // Only deinit the current bitmap if a bitmap was previously loaded
  if (s_data.current_icon != 0) {
    heap_bitmap_deinit(&s_data.icon_bitmap);
  }
  // Keep track of what the current icon is
  s_data.current_icon = resource_id;
  // Load the new icon
  heap_bitmap_init(&s_data.icon_bitmap, resource_id);

  layer_mark_dirty(&(s_data.icon_layer.layer));
    
  light_enable_interaction();
    
  vibes_short_pulse();
}

// TODO: Error handling
static void sync_error_callback(DictionaryResult dict_error, AppMessageResult app_message_error, void *context) {
}

static void sync_tuple_changed_callback(const uint32_t key, const Tuple* new_tuple, const Tuple* old_tuple, void* context) {

  switch (key) {
  case EMOJIPET_ICON_KEY:
    load_bitmap(EMOJI_ARRAY[new_tuple->value->uint8]);
    bitmap_layer_set_bitmap(&s_data.icon_layer, &s_data.icon_bitmap.bmp);
    break;
  default:
    return;
  }
}

static void emojipet_app_init(AppContextRef c) {

  s_data.current_icon = 0;

  resource_init_current_app(&FACEPET_APP_RESOURCES);

  Window* window = &s_data.window;
  window_init(window, "EmojiPet");
  window_set_background_color(window, GColorBlack);
  window_set_fullscreen(window, true);

  GRect icon_rect = (GRect) {(GPoint) {0, 0}, (GSize) { 168, 144 }};
  bitmap_layer_init(&s_data.icon_layer, icon_rect);
  layer_add_child(&window->layer, &s_data.icon_layer.layer);

  Tuplet initial_values[] = {
    TupletInteger(EMOJIPET_ICON_KEY, (uint8_t) 0),
  };
  app_sync_init(&s_data.sync, s_data.sync_buffer, sizeof(s_data.sync_buffer), initial_values, ARRAY_LENGTH(initial_values),
                sync_tuple_changed_callback, sync_error_callback, NULL);

  window_stack_push(window, true);
}

static void emojipet_app_deinit(AppContextRef c) {
  app_sync_deinit(&s_data.sync);
  if (s_data.current_icon != 0) {
    heap_bitmap_deinit(&s_data.icon_bitmap);
  }
}

void pbl_main(void *params) {
  PebbleAppHandlers handlers = {
    .init_handler = &emojipet_app_init,
    .deinit_handler = &emojipet_app_deinit,
    .messaging_info = {
      .buffer_sizes = {
        .inbound = 64,
        .outbound = 16,
      }
    }
  };
  app_event_loop(params, &handlers);
}
