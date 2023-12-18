//
//  PhotoViewModel.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import Foundation
import PhotosUI
import SwiftUI

// A view model that integrates a photos picker
@MainActor final class PhotoViewModel: ObservableObject {
  // A class that manages an image selected in the photos picker
  @MainActor final class ImageAttachment: ObservableObject, Identifiable {
    // Statuses that indicate the app's progress in loading a selected photo
    enum Status {
      case loading // A status indicating that the app has requested a photo
      case finished(Image) // A status indicating that the app has loaded a
      // photo
      case failed(Error) // A status indicating that the app failed to load a
      // photo
      var isFailed: Bool {
        switch self {
        case .failed: true
        default: false
        }
      }
    }

    // An error that indicates why a photo has failed to load
    enum LoadingError: Error {
      case contentTypeNotSupported
    }

    private let pickerItem: PhotosPickerItem // A reference to a selected photo
    // in the picker

    @Published var status: Status? // A load status for the photo

    @Published var description = "" // A textual description for the photo

    nonisolated var id: String { // An identifier for the photo
      pickerItem.identifier
    }

    // Creates an image attachment for the given picker item
    init(_ pickerItem: PhotosPickerItem) {
      self.pickerItem = pickerItem
    }

    // Loads the photo that the picker item features
    func loadImage() async {
      guard status == nil || status!.isFailed else {
        return // Only loads for the first time or re-load after failure
      }
      status = .loading
      do {
        if let data = try await pickerItem
          .loadTransferable(type: Data.self),
          let uiImage = UIImage(data: data)
        {
          status = .finished(Image(uiImage: uiImage))
        } else {
          throw LoadingError.contentTypeNotSupported
        }
      } catch {
        status = .failed(error)
      }
    }
  }

  // An array of image attachments for the picker's selected photos
  @Published var attachments = [ImageAttachment]()

  // A dictionary that stores previously loaded image attachments for
  // performance
  private var attachmentByIdentifier = [String: ImageAttachment]()

  // An array of items for the picker's selected photos
  // On set, this method updates the image attachements for the current
  // selection
  @Published var selection = [PhotosPickerItem]() {
    didSet {
      // Update the attachments according to the current picker selection
      let newAttachments = selection.map { item in
        // Access an existing attachement, if it exists; otherwise, create a new
        // attachment
        attachmentByIdentifier[item.identifier] ?? ImageAttachment(item)
      }
      // Update the saved attachments array for any new attachment loaded in
      // scope
      let newAttachmentByIdentifier = newAttachments
        .reduce(into: [:]) { partialResult, attachment in
          partialResult[attachment.id] = attachment
        }
      // To support asynchronous access, assign new arrays to the instance
      // properties rather than updating the existing arrays.
      attachments = newAttachments
      attachmentByIdentifier = newAttachmentByIdentifier
    }
  }
}

private extension PhotosPickerItem {
  var identifier: String {
    guard let identifier = itemIdentifier else {
      fatalError("The photos picker lacks a photo library")
    }
    return identifier
  }
}
