return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('todo-comments').setup {
      signs = true,
      keywords = {
        TODO = {
          alt = { 'ToDo', 'todo', 'todolist', 'ToDoList' },
        },
      },
      highlight = {
        pattern = [[.*<((KEYWORDS)%(\((user|[iI]583641)\))?):]],
      },
    }
    vim.keymap.set('n', ']T', function()
      require('todo-comments').jump_next()
    end, { desc = 'Next [t]odo comment' })

    vim.keymap.set('n', '[T', function()
      require('todo-comments').jump_prev()
    end, { desc = 'Previous [t]odo comment' })
  end,
}
