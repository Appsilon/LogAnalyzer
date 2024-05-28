box::use(
  testthat[
    describe,
    expect_equal,
    it
  ],
)

box::use(
  app/logic/job_list_utils[
    process_job_data
  ],
)

describe("process_job_data()", {

  it("returns processed jobs when job_list_data is not empty", {
    job_list <- data.frame(
      id = c(1, 2),
      key = c("key1", "key2"),
      start_time = c("2021-01-01 00:00:00", "2021-01-02 00:00:00"),
      end_time = c("2021-01-01 12:00:00", "2021-01-02 12:00:00")
    )

    expected_result <- data.frame(
      job = c("1_-_key1_-_2021-01-01 00:00:00_-_2021-01-01 12:00:00",
              "2_-_key2_-_2021-01-02 00:00:00_-_2021-01-02 12:00:00")
    )

    result <- process_job_data(job_list)
    expect_equal(result, expected_result)
  })

  it("returns an empty dataframe when job_list_data is empty", {
    job_list <- data.frame(
      id = integer(),
      key = character(),
      start_time = character(),
      end_time = character()
    )

    expected_result <- data.frame(
      job = character()
    )

    result <- process_job_data(job_list)
    expect_equal(result, expected_result)
  })

  it("handles NULL input gracefully", {
    job_list <- NULL

    expected_result <- data.frame(
      job = character()
    )

    result <- process_job_data(job_list)
    expect_equal(result, expected_result)
  })

})
