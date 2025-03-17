require "test_helper"

class PaymentStatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_state = payment_states(:one)
  end

  test "should get index" do
    get payment_states_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_state_url
    assert_response :success
  end

  test "should create payment_state" do
    assert_difference("PaymentState.count") do
      post payment_states_url, params: { payment_state: { name: @payment_state.name } }
    end

    assert_redirected_to payment_state_url(PaymentState.last)
  end

  test "should show payment_state" do
    get payment_state_url(@payment_state)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_state_url(@payment_state)
    assert_response :success
  end

  test "should update payment_state" do
    patch payment_state_url(@payment_state), params: { payment_state: { name: @payment_state.name } }
    assert_redirected_to payment_state_url(@payment_state)
  end

  test "should destroy payment_state" do
    assert_difference("PaymentState.count", -1) do
      delete payment_state_url(@payment_state)
    end

    assert_redirected_to payment_states_url
  end
end
