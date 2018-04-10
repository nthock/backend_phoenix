alias BackendPhoenix.Accounts

Accounts.create_user(%{
  name: "Jimmy",
  email: "jimmy@example.com",
  designation: "Founder",
  password: "password",
  super_admin: true,
  admin: true
})
