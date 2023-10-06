### Assumption
​
I am not considering print as an operation, hence I'm not pushing it to undo_stack(history).
​
### Description
​
I have used simple Object Oriented approach to solve this problem. I have created a TextEditor class with all necessary functions i.e. append, delete, print, undo and proccess_command. Additional method(s) for file handling are also added.
Attribute `undo_stack` keeps the record history of every operation performed so far, and helps in undo(ing) the operation.
​
### Requirements
​
- `ruby-3.0.0`
- `bundler-2.2.3`
​
### Specs
​
- `gem install rspec`
- `rspec ./editor_spec`
