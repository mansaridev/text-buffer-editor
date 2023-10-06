# frozen_string_literal: true

require './text_buffer_editor_error'

# Buffer Text Editor class
class TextBufferEditor
  def initialize
    @buffer = ''
    @undo_stack = []
  end

  def append(str)
    @buffer += str
  end

  def delete(index)
    @buffer.slice!(-index..-1)
  end

  def print(index)
    puts @buffer[index]
  end

  def undo
    if @undo_stack.empty?
      puts 'Nothing to undo'
    else
      operation = @undo_stack.pop
      case operation[0]
      when :append
        delete(operation[1].length)
      when :delete
        append(operation[1])
      end
    end
  end

  def process_command(command)
    parts = command.split(' ')
    command_id = parts[0].to_i

    case command_id
    when 1
      s = parts[1..].join(' ')
      @undo_stack << [:append, s.dup]
      append(s)
    when 2
      n = parts[1].to_i
      @undo_stack << [:delete, @buffer[-n..].dup]
      delete(n)
    when 3
      n = parts[1].to_i
      print(n)
    when 4
      undo
    end
  end

  def process_file(file_path)
    File.open(file_path, 'r') do |file|
      file.each_line do |line|
        process_command(line.strip)
      end
    end
  rescue Errno::ENOENT
    raise TextBufferEditorError, TextBufferEditorError::FILE_NOT_FOUND % file_path
  rescue StandardError => e
    raise TextBufferEditorError, TextBufferEditorError::PROCESSING_ERROR % e.message
  end

  def save_to_file(file_path)
    File.open(file_path, 'w') do |file|
      file.puts(@buffer)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  editor = TextBufferEditor.new
  input_file = ARGV[0] || 'input.txt'
  output_file = 'output.txt'

  begin
    editor.process_file(input_file)
    editor.save_to_file(output_file)
    puts "File '#{input_file}' processed and saved to '#{output_file}'."
  rescue TextBufferEditorError => e
    puts e.message
  end
end
