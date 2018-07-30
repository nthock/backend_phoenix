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
          super_admin: false,
          admin: false
        }
      end

      def admin_factory do
        %User{
          name: "Johnny",
          email: "johnny@example.com",
          designation: "Founder",
          password: "password",
          super_admin: false,
          admin: true
        }
      end

      def super_admin_factory do
        %User{
          name: "Jonathan",
          email: "jonathan@example.com",
          designation: "Founder",
          password: "password",
          super_admin: true,
          admin: true
        }
      end
    end
  end
end