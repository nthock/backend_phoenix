defmodule BackendPhoenix.UserFactory do
  alias BackendPhoenix.Accounts.Schema.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          name: "Jimmy",
          email: "jimmy@example.com",
          designation: "Founder",
          password: "password",
          super_admin: true,
          admin: true
        }
      end
    end
  end
end