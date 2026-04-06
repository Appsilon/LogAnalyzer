box::use(
  testthat[
    describe,
    expect_identical,
    expect_true,
    it
  ],
)

box::use(
  app/logic/general_utils[
    check_text_error,
    format_timestamp,
    generate_css_variables,
  ],
)

describe("check_text_error()", {
  it("returns TRUE for error keywords", {
    expect_true(
      check_text_error(
        "Error: job failed"
      )
    )
    expect_true(
      check_text_error(
        "Halt: job terminated"
      )
    )
    expect_true(
      check_text_error(
        "Error: file not found"
      )
    )
  })

  it("handles 'no error' and similar cases gracefully", {
    expect_true(
      !check_text_error(
        "No error detected"
      )
    )
    expect_true(
      !check_text_error(
        "No errors found"
      )
    )
  })

  it("returns FALSE for non-error keywords", {
    expect_true(
      !check_text_error(
        "Job completed successfully"
      )
    )
    expect_true(
      !check_text_error(
        "Processing"
      )
    )
  })
})

describe("format_timestamp()", {
  it("correctly formats timestamp", {
    expect_identical(
      format_timestamp(
        "2023-10-01T12:34:56Z"
      ),
      "2023-10-01 12:34:56"
    )
    expect_identical(
      format_timestamp(
        "2023-10-01T12:34:56.789Z"
      ),
      "2023-10-01 12:34:56"
    )
  })
})

describe("generate_css_variables()", {
  it("generates CSS variables correctly", {
    config <- list(
      colors = list(
        primary = "#FF5733",
        secondary = "#33FF57"
      )
    )
    expected_css <- ":root {\n  --primary: #FF5733;\n  --secondary: #33FF57;\n}"
    expect_identical(
      generate_css_variables(config),
      expected_css
    )
  })
})
