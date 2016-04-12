#pragma once


#import <stdint.h>
#import <openssl/evp.h>

struct encryption_ctx {
    EVP_CIPHER_CTX* ctx;
    uint8_t status;
    unsigned char iv[16];
    size_t iv_len;
    size_t bytes_remaining; // only for libsodium
    uint64_t ic; // only for libsodium
    uint8_t cipher;
};

#define STATUS_EMPTY 0
#define STATUS_INIT 1
#define STATUS_DESTORYED 2

#define kShadowsocksMethods 13

extern const char *shadowsocks_encryption_names[];

extern void encrypt_buf(struct encryption_ctx* ctx, unsigned char *buf, size_t *len);
extern void decrypt_buf(struct encryption_ctx* ctx, unsigned char *buf, size_t *len);

extern int send_encrypt(struct encryption_ctx* ctx, int sock, unsigned char *buf, size_t *len, int flags);
extern int recv_decrypt(struct encryption_ctx* ctx, int sock, unsigned char *buf, size_t *len, int flags);

extern void init_encryption(struct encryption_ctx* ctx);
extern void cleanup_encryption(struct encryption_ctx* ctx);

extern void config_encryption(const char *password, const char *method);

extern unsigned char *shadowsocks_key;



