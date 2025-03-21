# frozen_string_literal: true

class OrderStatesController < ApplicationController
  before_action :set_order_state, only: %i[show edit update destroy]

  # GET /order_states or /order_states.json
  def index
    @order_states = OrderState.all
  end

  # GET /order_states/1 or /order_states/1.json
  def show; end

  # GET /order_states/new
  def new
    @order_state = OrderState.new
  end

  # GET /order_states/1/edit
  def edit; end

  # POST /order_states or /order_states.json
  def create
    @order_state = OrderState.new(order_state_params)

    respond_to do |format|
      if @order_state.save
        format.html { redirect_to @order_state, notice: 'Order state was successfully created.' }
        format.json { render :show, status: :created, location: @order_state }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_states/1 or /order_states/1.json
  def update
    respond_to do |format|
      if @order_state.update(order_state_params)
        format.html { redirect_to @order_state, notice: 'Order state was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_state }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_states/1 or /order_states/1.json
  def destroy
    @order_state.destroy

    respond_to do |format|
      format.html do
        redirect_to order_states_path, status: :see_other, notice: 'Order state was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order_state
    @order_state = OrderState.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_state_params
    params.require(:order_state).permit(:order_id, :state_id)
  end
end
