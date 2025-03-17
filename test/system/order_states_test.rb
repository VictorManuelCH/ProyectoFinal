require "application_system_test_case"

class OrderStatesTest < ApplicationSystemTestCase
  setup do
    @order_state = order_states(:one)
  end

  test "visiting the index" do
    visit order_states_url
    assert_selector "h1", text: "Order states"
  end

  test "should create order state" do
    visit order_states_url
    click_on "New order state"

    fill_in "Order", with: @order_state.order_id
    fill_in "State", with: @order_state.state_id
    click_on "Create Order state"

    assert_text "Order state was successfully created"
    click_on "Back"
  end

  test "should update Order state" do
    visit order_state_url(@order_state)
    click_on "Edit this order state", match: :first

    fill_in "Order", with: @order_state.order_id
    fill_in "State", with: @order_state.state_id
    click_on "Update Order state"

    assert_text "Order state was successfully updated"
    click_on "Back"
  end

  test "should destroy Order state" do
    visit order_state_url(@order_state)
    click_on "Destroy this order state", match: :first

    assert_text "Order state was successfully destroyed"
  end
end
