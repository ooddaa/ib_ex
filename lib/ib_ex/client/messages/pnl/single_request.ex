defmodule IbEx.Client.Messages.Pnl.SingleRequest do
  @moduledoc """
  Request used to request the PnL of a single position.

  The input parameters to create this message are:

  request_id: unique identifier for the request
  account: account associated with the position
  conid: Unique identifier of the instrument
  model_code: (undetermined)
  """

  alias IbEx.Client.Messages.Requests

  defstruct message_id: nil, request_id: nil, account: nil, model_code: "", conid: nil

  @type t :: %__MODULE__{
          message_id: integer(),
          request_id: String.t(),
          account: String.t(),
          model_code: String.t(),
          conid: String.t()
        }

  @spec new(String.t(), String.t(), String.t(), String.t()) :: {:ok, t()} | {:error, :not_implemented}
  def new(request_id, account, conid, model_code \\ "") do
    case Requests.message_id_for(__MODULE__) do
      {:ok, message_id} ->
        {
          :ok,
          %__MODULE__{
            message_id: message_id,
            request_id: request_id,
            account: account,
            conid: conid,
            model_code: model_code
          }
        }

      _ ->
        {:error, :not_implemented}
    end
  end

  defimpl String.Chars, for: __MODULE__ do
    alias IbEx.Client.Messages.Base

    def to_string(msg) do
      Base.build([msg.message_id, msg.request_id, msg.account, msg.model_code, msg.conid])
    end
  end

  defimpl Inspect, for: __MODULE__ do
    def inspect(msg, _opts) do
      """
      --> Pnl.SingleRequest{
        id: #{msg.message_id},
        request_id: #{msg.request_id},
        account: #{msg.account},
        model_code: #{msg.model_code},
        conid: #{msg.conid}
      }
      """
    end
  end
end
