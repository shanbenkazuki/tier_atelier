// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import DeleteTierImageController from "./delete_tier_image_controller"
application.register("delete-tier-image", DeleteTierImageController)

import DownloadTierController from "./download_tier_controller"
application.register("download-tier", DownloadTierController)

import DynamicFieldController from "./dynamic_field_controller"
application.register("dynamic-field", DynamicFieldController)

import ItemCountCheckerController from "./item_count_checker_controller"
application.register("item-count-checker", ItemCountCheckerController)

import ItemDragController from "./item_drag_controller"
application.register("item-drag", ItemDragController)

import UploadItemPreviewController from "./upload_item_preview_controller"
application.register("upload-item-preview", UploadItemPreviewController)

import UploadProgressController from "./upload_progress_controller"
application.register("upload-progress", UploadProgressController)
