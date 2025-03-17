require "application_system_test_case"

class ProductReviewsTest < ApplicationSystemTestCase
  setup do
    @product_review = product_reviews(:one)
  end

  test "visiting the index" do
    visit product_reviews_url
    assert_selector "h1", text: "Product reviews"
  end

  test "should create product review" do
    visit product_reviews_url
    click_on "New product review"

    fill_in "Product", with: @product_review.product_id
    fill_in "Rating", with: @product_review.rating
    fill_in "Review text", with: @product_review.review_text
    click_on "Create Product review"

    assert_text "Product review was successfully created"
    click_on "Back"
  end

  test "should update Product review" do
    visit product_review_url(@product_review)
    click_on "Edit this product review", match: :first

    fill_in "Product", with: @product_review.product_id
    fill_in "Rating", with: @product_review.rating
    fill_in "Review text", with: @product_review.review_text
    click_on "Update Product review"

    assert_text "Product review was successfully updated"
    click_on "Back"
  end

  test "should destroy Product review" do
    visit product_review_url(@product_review)
    click_on "Destroy this product review", match: :first

    assert_text "Product review was successfully destroyed"
  end
end
