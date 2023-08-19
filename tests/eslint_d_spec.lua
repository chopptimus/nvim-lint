describe("linter.eslint_d", function()
  it("ignores empty output", function()
    local parser = require("lint.linters.eslint_d").parser
    assert.are.same({}, parser("", vim.api.nvim_get_current_buf()))
    assert.are.same({}, parser("  ", vim.api.nvim_get_current_buf()))
  end)

  it("can parse output", function()
    local parser = require("lint.linters.eslint_d").parser
    local result = parser(
      [[
/directory/file.js
  1:10  error  'testFunc' is defined but never used                                                                                   no-unused-vars
  4:16  error  This branch can never execute. Its condition is a duplicate or covered by previous conditions in the if-else-if chain  no-dupe-else-if

✖ 2 problems (2 errors, 0 warnings)
    ]],
      vim.api.nvim_get_current_buf()
    )
    assert.are.same(2, #result)
    local expected_1 = {
      code = "no-unused-vars",
      col = 9,
      end_col = 9,
      end_lnum = 0,
      lnum = 0,
      message = "'testFunc' is defined but never used",
      severity = 1,
      source = "eslint_d",
      user_data = {
        lsp = {
          code = "no-unused-vars",
        },
      },
    }
    assert.are.same(expected_1, result[1])

    local expected_2 = {
      code = "no-dupe-else-if",
      col = 15,
      end_col = 15,
      end_lnum = 3,
      lnum = 3,
      message = "This branch can never execute. Its condition is a duplicate or covered by previous conditions in the if-else-if chain",
      severity = 1,
      source = "eslint_d",
      user_data = {
        lsp = {
          code = "no-dupe-else-if",
        },
      },
    }
    assert.are.same(expected_2, result[2])
  end)
end)