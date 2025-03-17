require "application_system_test_case"

class PaymentStatesTest < ApplicationSystemTestCase
  setup do
    @payment_state = payment_states(:one)
  end

  test "visiting the index" do
    visit payment_states_url
    assert_selector "h1", text: "Payment states"
  end

  test "should create payment state" do
    visit payment_states_url
    click_on "New payment state"

    fill_in "Name", with: @payment_state.name
    click_on "Create Payment state"

    assert_text "Payment state was successfully created"
    click_on "Back"
  end

  test "should update Payment state" do
    visit payment_state_url(@payment_state)
    click_on "Edit this payment state", match: :first

    fill_in "Name", with: @payment_state.name
    click_on "Update Payment state"

    assert_text "Payment state was successfully updated"
    click_on "Back"
  end

  test "should destroy Payment state" do
    visit payment_state_url(@payment_state)
    click_on "Destroy this payment state", match: :first

    assert_text "Payment state was successfully destroyed"
  end
end
