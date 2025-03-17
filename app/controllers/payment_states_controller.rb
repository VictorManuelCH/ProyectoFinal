class PaymentStatesController < ApplicationController
  before_action :set_payment_state, only: %i[ show edit update destroy ]

  # GET /payment_states or /payment_states.json
  def index
    @payment_states = PaymentState.all
  end

  # GET /payment_states/1 or /payment_states/1.json
  def show
  end

  # GET /payment_states/new
  def new
    @payment_state = PaymentState.new
  end

  # GET /payment_states/1/edit
  def edit
  end

  # POST /payment_states or /payment_states.json
  def create
    @payment_state = PaymentState.new(payment_state_params)

    respond_to do |format|
      if @payment_state.save
        format.html { redirect_to @payment_state, notice: "Payment state was successfully created." }
        format.json { render :show, status: :created, location: @payment_state }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_states/1 or /payment_states/1.json
  def update
    respond_to do |format|
      if @payment_state.update(payment_state_params)
        format.html { redirect_to @payment_state, notice: "Payment state was successfully updated." }
        format.json { render :show, status: :ok, location: @payment_state }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_states/1 or /payment_states/1.json
  def destroy
    @payment_state.destroy

    respond_to do |format|
      format.html { redirect_to payment_states_path, status: :see_other, notice: "Payment state was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_state
      @payment_state = PaymentState.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_state_params
      params.require(:payment_state).permit(:name)
    end
end
