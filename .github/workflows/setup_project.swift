lane :setup do
  setup_project
end

private_lane :setup_project do
  create_keychain(
    name: "actiontest_keychain",
    password: "meow",
    default_keychain: true,
    unlock: true,
    timeout: 3600,
    lock_when_sleeps: false
  )
end
