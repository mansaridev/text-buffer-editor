# frozen_string_literal: true

# Constants for error messages
class TextBufferEditorError < StandardError
  FILE_NOT_FOUND = "Error: The file '%s' does not exist."
  PROCESSING_ERROR = 'An error occurred while processing the file: %s'
end
