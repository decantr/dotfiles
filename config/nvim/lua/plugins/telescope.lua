return {
	-- change some telescope options and a keymap to browse plugin files
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			-- add a keymap to browse plugin files
			-- stylua: ignore
			-- {
			-- 	"<leader>fp",
			-- 	function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
			-- 	desc = "Find Plugin File",
			-- },
		},
		-- change some options
		-- opts = {
		-- 	defaults = {
		-- 		layout_strategy = "horizontal",
		-- 		layout_config = { prompt_position = "top" },
		-- 		sorting_strategy = "ascending",
		-- 		winblend = 0,
		-- 	},
		-- },
		opts = function()
			local actions = require("telescope.actions")

			local open_with_trouble = function(...)
				return require("trouble.providers.telescope").open_with_trouble(...)
			end
			local open_selected_with_trouble = function(...)
				return require("trouble.providers.telescope").open_selected_with_trouble(...)
			end
			local find_files_no_ignore = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				LazyVim.telescope("find_files", { no_ignore = true, default_text = line })()
			end
			local find_files_with_hidden = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				LazyVim.telescope("find_files", { hidden = true, default_text = line })()
			end
			local select_one_or_multi = function(prompt_bufnr)
				local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
				local multi = picker:get_multi_selection()
				if not vim.tbl_isempty(multi) then
					require("telescope.actions").close(prompt_bufnr)
					for _, j in pairs(multi) do
						if j.path ~= nil then
							vim.cmd(string.format("%s %s", "edit", j.path))
						end
					end
				else
					require("telescope.actions").select_default(prompt_bufnr)
				end
			end

			return {
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
					mappings = {
						i = {
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<CR>"] = select_one_or_multi,
							["<d-t>"] = open_with_trouble,
							["<c-t>"] = open_selected_with_trouble,
							["<c-i>"] = find_files_no_ignore,
							["<c-h>"] = find_files_with_hidden,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
						},
						n = {
							["q"] = actions.close,
							["<CR>"] = select_one_or_multi,
						},
					},
				},
			}
		end,
	},
}
