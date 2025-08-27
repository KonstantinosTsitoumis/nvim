return {
  'nvim-neotest/neotest',
  dependencies = {
    { 'fredrikaverpil/neotest-golang', version = '*' },
    'mfussenegger/nvim-dap', -- DAP core
    'leoluz/nvim-dap-go', -- DAP Go support
    'rcarriga/nvim-dap-ui', -- DAP UI
    'jay-babu/mason-nvim-dap.nvim',
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    local neotest = require 'neotest'

    neotest.setup {
      nio = {},
      summary = {
        follow = true,
        open = 'botright vsplit | vertical resize 50', -- Better summary window positioning
      },
      icons = {
        expanded = '',
        child_prefix = '',
        child_indent = '',
        final_child_prefix = '',
        non_collapsible = '',
        collapsed = '',

        passed = '',
        running = '',
        failed = '',
        unknown = '',
      },
      adapters = {
        require 'neotest-golang' {
          args = { '-count=1', '-timeout=60s', '-v' }, -- Added verbose flag
          recursive_run = true,
          dap_go_enabled = true,
          run_package = true,
          -- Added testify support for better assertion handling
          testify_enabled = true,
        },
      },
      -- Added output configuration
      output = {
        open_on_run = false, -- Don't auto-open output window
      },
      -- Added diagnostic configuration
      diagnostic = {
        enabled = true,
        severity = vim.diagnostic.severity.ERROR,
      },
    }

    -- Setup DAP for Go
    local mason_dap = require 'mason-nvim-dap'
    mason_dap.setup {
      automatic_setup = true,
      ensure_installed = { 'delve' }, -- ensures `delve` is installed
    }

    require('dap-go').setup {
      -- Additional delve configuration
      delve = {
        detached = vim.fn.has 'win32' == 0, -- Don't detach on Windows
      },
    }

    -- Optional: Setup virtual text for showing variable values
    -- Uncomment if you added nvim-dap-virtual-text dependency
    -- require("nvim-dap-virtual-text").setup()

    -- Add debug keybinding
    vim.keymap.set('n', '<leader>tI', ':NeotestDebugInfo<CR>', { desc = 'Test: Debug info' })

    -- Keybindings for running tests with Neotest
    vim.keymap.set('n', '<leader>ttn', function()
      print 'Running nearest test...'
      neotest.run.run() -- Run nearest test
      print ''
    end, { desc = 'Test: Run nearest' })

    vim.keymap.set('n', '<leader>ttf', function()
      neotest.run.run(vim.fn.expand '%') -- Run test file
    end, { desc = 'Test: Run file' })

    vim.keymap.set('n', '<leader>tta', function()
      neotest.run.run(vim.fn.getcwd()) -- Run all tests in project
    end, { desc = 'Test: Run all' })

    vim.keymap.set('n', '<leader>tts', function()
      neotest.run.stop() -- Stop test
    end, { desc = 'Test: Stop' })

    vim.keymap.set('n', '<leader>tto', function()
      neotest.output.open { enter = true } -- Open test output
    end, { desc = 'Test: Open output' })

    vim.keymap.set('n', '<leader>ttO', function()
      neotest.output_panel.toggle() -- Toggle output panel
    end, { desc = 'Test: Toggle output panel' })

    vim.keymap.set('n', '<leader>ttu', function()
      neotest.summary.toggle() -- Toggle test summary
    end, { desc = 'Test: Toggle summary' })

    -- Debug test keybindings
    vim.keymap.set('n', '<leader>ttd', function()
      neotest.run.run { strategy = 'dap' } -- Test Method with DAP
    end, { desc = 'Test: Debug nearest' })

    vim.keymap.set('n', '<leader>ttD', function()
      neotest.run.run { vim.fn.expand '%', strategy = 'dap' } -- Test Class with DAP
    end, { desc = 'Test: Debug file' })

    -- Watch mode
    vim.keymap.set('n', '<leader>ttw', function()
      neotest.watch.toggle(vim.fn.expand '%')
    end, { desc = 'Test: Watch file' })

    -- Jump to next/prev failed test
    vim.keymap.set('n', ']t', function()
      neotest.jump.next { status = 'failed' }
    end, { desc = 'Next failed test' })

    vim.keymap.set('n', '[t', function()
      neotest.jump.prev { status = 'failed' }
    end, { desc = 'Previous failed test' })

    -- DAP keybindings
    local dap = require 'dap'

    -- add breakpoint
    vim.keymap.set('n', '<leader>ttb', function()
      dap.toggle_breakpoint()
    end, { desc = 'Toggle Breakpoint' })
    --
    -- Define custom highlight groups with better colors
    vim.api.nvim_set_hl(0, 'DapBreakpointText', { fg = '#e06c75', bold = true }) -- Red
    vim.api.nvim_set_hl(0, 'DapStoppedText', { fg = '#98c379', bold = true }) -- Green
    vim.api.nvim_set_hl(0, 'DapBreakpointLine', { bg = '#2d1b21' }) -- Subtle red background
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#1e2718' }) -- Subtle green background
    vim.api.nvim_set_hl(0, 'DapBreakpointNum', { fg = '#e06c75', bold = true })
    vim.api.nvim_set_hl(0, 'DapStoppedNum', { fg = '#98c379', bold = true })

    -- Sign definitions with better icons
    vim.fn.sign_define('DapBreakpoint', {
      text = '●',
      texthl = 'DapBreakpointText',
      linehl = 'DapBreakpointLine',
      numhl = 'DapBreakpointNum',
    })
    vim.fn.sign_define('DapStopped', {
      text = '▶',
      texthl = 'DapStoppedText',
      linehl = 'DapStoppedLine',
      numhl = 'DapStoppedNum',
    })
    vim.fn.sign_define('DapBreakpointCondition', {
      text = '◆',
      texthl = 'DapBreakpointText',
      linehl = 'DapBreakpointLine',
      numhl = 'DapBreakpointNum',
    })
    vim.fn.sign_define('DapLogPoint', {
      text = '◉',
      texthl = 'DapBreakpointText',
      linehl = 'DapBreakpointLine',
      numhl = 'DapBreakpointNum',
    })

    -- Debug keybindings
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle breakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set conditional breakpoint' })

    -- vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Continue' })
    -- vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step into' })
    -- vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step over' })
    -- vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Debug: Step out' })
    -- vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug: Open REPL' })
    -- vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug: Run last' })
    -- vim.keymap.set('n', '<leader>dq', dap.terminate, { desc = 'Debug: Quit' })

    -- Function key bindings (keeping your originals but with better descriptions)
    vim.keymap.set('n', '<F1>', dap.continue, { desc = 'Continue' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Step over' })
    vim.keymap.set('n', '<F3>', dap.step_into, { desc = 'Step into' })
    vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Step out' })

    local ui = require 'dapui'

    ui.setup {
      -- Better DAP UI layout
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          size = 10,
          position = 'bottom',
        },
      },
    }

    -- Manual DAP UI toggle
    vim.keymap.set('n', '<leader>du', ui.toggle, { desc = 'Debug: Toggle UI' })

    -- Auto-open/close DAP UI
    dap.listeners.after.event_initialized['dapui_config'] = function()
      ui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      ui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      ui.close()
    end

    -- Go-specific test functions
    vim.keymap.set('n', '<leader>tgt', function()
      require('dap-go').debug_test()
    end, { desc = 'Go: Debug test' })

    vim.keymap.set('n', '<leader>tgl', function()
      require('dap-go').debug_last_test()
    end, { desc = 'Go: Debug last test' })
  end,
}
