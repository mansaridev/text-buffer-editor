# text_buffer_editor_spec.rb

require './editor'
require './text_buffer_editor_error.rb'

RSpec.describe TextBufferEditor do
  let(:editor) { TextBufferEditor.new }

  describe '#append' do
    it 'appends text to the buffer' do
      editor.append('abc')
      expect(editor.instance_variable_get(:@buffer)).to eq('abc')
    end
  end

  describe '#delete' do
    it 'deletes characters from the buffer' do
      editor.instance_variable_set(:@buffer, 'abcdef')
      editor.delete(3)
      expect(editor.instance_variable_get(:@buffer)).to eq('abc')
    end
  end

  describe '#print' do
    it 'prints the nth character of the buffer' do
      editor.instance_variable_set(:@buffer, 'abcdef')
      expect { editor.print(3) }.to output("d\n").to_stdout
    end
  end

  describe '#undo' do
    it 'undoes the last operation' do
      editor.append('abc')
      editor.delete(3)
      editor.instance_variable_set(:@undo_stack, [[:delete, 'abc']])
      editor.undo
      expect(editor.instance_variable_get(:@buffer)).to eq('abc')
    end

    it 'handles undo when the undo stack is empty' do
      expect { editor.undo }.to output("Nothing to undo\n").to_stdout
    end
  end

  describe '#process_file' do
    it 'processes a valid file' do
      input_file = 'valid_input.txt'
      File.write(input_file, "1 abc\n3 3\n2 3\n")
      expect { editor.process_file(input_file) }.not_to raise_error
      File.delete(input_file) # Clean up the test file
    end

    it 'handles a file not found error' do
      expect do
        editor.process_file('nonexistent_file.txt')
      end.to raise_error(TextBufferEditorError,
                         "Error: The file 'nonexistent_file.txt' does not exist.")
    end
  end
end
