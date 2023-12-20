# RailsSessionCipher

## Overview

RailsSessionCipher is a Ruby gem providing an efficient and secure way to encrypt and decrypt Rails session cookies using AES-256-GCM cipher. It utilizes OpenSSL for cryptographic operations and is designed to be easily integrated into any Rails application.

## Features

- **AES-256-GCM Encryption:** Utilizes AES-256-GCM for high-security encryption.
- **Configurable:** Offers customizable options for salt, hash digest class, and iteration count.
- **Error Handling:** Includes custom error handling for invalid messages during decryption.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_session_cipher'
```

And then execute:

```
bundle install
```

Or install it yourself as:
```
gem install rails_session_cipher
```

## Usage
# Configuration
Before using RailsSessionCipher, you need to configure it with your preferred settings:

```ruby
RailsSessionCipher.configure do |config|
  config.salt = "your_salt_here"
  config.iteration_count = 20000
  config.hash_digest_class = OpenSSL::Digest::SHA256
end
```

# Encrypting Data
To encrypt data:

```ruby
encrypted_data = RailsSessionCipher.encrypt(data, key, iv, auth_tag)
```

- data: The data you want to encrypt.
- key: Your secret key.
- iv: Initialization vector.
- auth_tag: Authentication tag.
- Options can be passed for salt and hash digest class.

# Decrypting Data
To decrypt data:

```ruby
decrypted_data = RailsSessionCipher.decrypt(session_cookie, key)
```
- session_cookie: Encrypted session cookie string.
- key: Your secret key.
- Options can be passed for salt and hash digest class.

## Error Handling
When decryption fails due to invalid data, an InvalidMessage error is raised.

# Dependencies
Ruby
OpenSSL