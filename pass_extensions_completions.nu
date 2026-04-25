## pass otp section

def "extract passwords" [] {
  let store_dir = ($env.PASSWORD_STORE_DIR? | default "~/.password-store" | path expand)

  # Safely join the path for the glob search
  let search_pattern = ($store_dir | path join "**/*.gpg")

  # Run the glob and clean up the output
  glob $search_pattern
  | path relative-to $store_dir
  | str replace --regex '\.gpg$' ''
}

# pass otp

export def "nu-complete pass-otp-subcommands" [] {
  ["append", "code", "insert", "uri", "validate"] ++ (extract passwords)
}

export extern "pass otp" [
  subcommand: string@"nu-complete pass-otp-subcommands"
  --clip (-c)
  --help (-h)
]

# If actually need the original pass otp --help run
# `^pass otp --help`

# pass otp insert

export extern "pass otp insert" [
  entry: string@"extract passwords"
  --force (-f)
  --echo (-e)
  --secret (-s)
  --issuer (-i):string
  --account (-a):string
]

# pass otp uri

export extern "pass otp uri" [
  entry: string@"extract passwords"
  --clip (-c)
  --qrcode (-q)
]

# pass otp validate uri

export extern "pass otp validate" [
  uri: string
]

# pass otp append

export extern "pass otp append" [
  entry: string@"extract passwords"
  --force (-f)
  --echo (-e)
  --secret (-s)
  --issuer (-i):string
  --account (-a):string
]
