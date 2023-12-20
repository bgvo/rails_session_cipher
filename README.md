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
### Configuration
Before using RailsSessionCipher, you need to configure it with your preferred settings:

```ruby
RailsSessionCipher.configure do |config|
  config.salt = "your_salt_here"
  config.iteration_count = 20000
  config.hash_digest_class = OpenSSL::Digest::SHA256
end
```

### Encrypting Data
To encrypt data:

```ruby
encrypted_data = RailsSessionCipher.encrypt(data, key, iv, auth_tag)
```

- data: The data you want to encrypt.
- key: Your secret key.
- iv: Initialization vector.
- auth_tag: Authentication tag.
- Options can be passed for salt and hash digest class.

### Decrypting Data
To decrypt data:

```ruby
decrypted_data = RailsSessionCipher.decrypt(session_cookie, key)
```
- session_cookie: Encrypted session cookie string.
- key: Your secret key.
- Options can be passed for salt and hash digest class.

### Error Handling
When decryption fails due to invalid data, an InvalidMessage error is raised.

### Benchmarking

To benchmark the performance of encryption and decryption, run the following script:

```bash
ruby benchmarks/encrypt_decrypt_benchmark.rb
```

```bash
Rehearsal --------------------------------------------
Encrypt:   0.028632   0.000071   0.028703 (  0.028811)
Decrypt:   0.023406   0.000186   0.023592 (  0.023833)
----------------------------------- total: 0.052295sec

               user     system      total        real
Encrypt:   0.031002   0.000115   0.031117 (  0.031190)
Decrypt:   0.030445   0.000050   0.030495 (  0.030541)
```

This benchmark was run on a MacBook Pro (16-inch, 2019) with a 2.6 GHz 6-Core Intel Core i7 processor, AMD Radeon Pro 5300M 4 GB and Intel UHD Graphics 630 1536 MB graphics, 16 GB 2667 MHz DDR4 memory, running macOS 13.4.1.

## Dependencies
Ruby
OpenSSL
