
static const int gmx_ciphersuites[] =
{
  /* All AES-256 ephemeral suites */
  TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
  TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
  //TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,
  TLS_ECDHE_ECDSA_WITH_AES_256_CCM,
  TLS_DHE_RSA_WITH_AES_256_CCM,
  TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,
  TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
  //TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,
  TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,
  TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,
  //TLS_DHE_RSA_WITH_AES_256_CBC_SHA,
  TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8,
  //TLS_DHE_RSA_WITH_AES_256_CCM_8,
  
  /* All CAMELLIA-256 ephemeral suites */
  TLS_ECDHE_ECDSA_WITH_CAMELLIA_256_GCM_SHA384,
  TLS_ECDHE_RSA_WITH_CAMELLIA_256_GCM_SHA384,
  //TLS_DHE_RSA_WITH_CAMELLIA_256_GCM_SHA384,
  TLS_ECDHE_ECDSA_WITH_CAMELLIA_256_CBC_SHA384,
  TLS_ECDHE_RSA_WITH_CAMELLIA_256_CBC_SHA384,
  //TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA256,
  //TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA,
  
  /* All AES-128 ephemeral suites */
  TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
  TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
  //TLS_DHE_RSA_WITH_AES_128_GCM_SHA256,
  TLS_ECDHE_ECDSA_WITH_AES_128_CCM,
  TLS_DHE_RSA_WITH_AES_128_CCM,
  TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,
  TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,
  //TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,
  TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,
  TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,
  //TLS_DHE_RSA_WITH_AES_128_CBC_SHA,
  TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8,
  TLS_DHE_RSA_WITH_AES_128_CCM_8,
  
  /* All CAMELLIA-128 ephemeral suites */
  TLS_ECDHE_ECDSA_WITH_CAMELLIA_128_GCM_SHA256,
  TLS_ECDHE_RSA_WITH_CAMELLIA_128_GCM_SHA256,
  //TLS_DHE_RSA_WITH_CAMELLIA_128_GCM_SHA256,
  TLS_ECDHE_ECDSA_WITH_CAMELLIA_128_CBC_SHA256,
  TLS_ECDHE_RSA_WITH_CAMELLIA_128_CBC_SHA256,
  //TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA256,
  //TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA,
  
  /* All remaining >= 128-bit ephemeral suites */
  TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA,
  TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA,
  //TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA,
  
  /* The PSK ephemeral suites */
  TLS_DHE_PSK_WITH_AES_256_GCM_SHA384,
  TLS_DHE_PSK_WITH_AES_256_CCM,
  TLS_ECDHE_PSK_WITH_AES_256_CBC_SHA384,
  TLS_DHE_PSK_WITH_AES_256_CBC_SHA384,
  TLS_ECDHE_PSK_WITH_AES_256_CBC_SHA,
  TLS_DHE_PSK_WITH_AES_256_CBC_SHA,
  TLS_DHE_PSK_WITH_CAMELLIA_256_GCM_SHA384,
  TLS_ECDHE_PSK_WITH_CAMELLIA_256_CBC_SHA384,
  TLS_DHE_PSK_WITH_CAMELLIA_256_CBC_SHA384,
  TLS_DHE_PSK_WITH_AES_256_CCM_8,
  
  TLS_DHE_PSK_WITH_AES_128_GCM_SHA256,
  TLS_DHE_PSK_WITH_AES_128_CCM,
  TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256,
  TLS_DHE_PSK_WITH_AES_128_CBC_SHA256,
  TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA,
  TLS_DHE_PSK_WITH_AES_128_CBC_SHA,
  TLS_DHE_PSK_WITH_CAMELLIA_128_GCM_SHA256,
  TLS_DHE_PSK_WITH_CAMELLIA_128_CBC_SHA256,
  TLS_ECDHE_PSK_WITH_CAMELLIA_128_CBC_SHA256,
  TLS_DHE_PSK_WITH_AES_128_CCM_8,
  
  TLS_ECDHE_PSK_WITH_3DES_EDE_CBC_SHA,
  TLS_DHE_PSK_WITH_3DES_EDE_CBC_SHA,
  
  /* All AES-256 suites */
  TLS_RSA_WITH_AES_256_GCM_SHA384,
  TLS_RSA_WITH_AES_256_CCM,
  TLS_RSA_WITH_AES_256_CBC_SHA256,
  TLS_RSA_WITH_AES_256_CBC_SHA,
  TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384,
  TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384,
  TLS_ECDH_RSA_WITH_AES_256_CBC_SHA,
  TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384,
  TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384,
  TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA,
  TLS_RSA_WITH_AES_256_CCM_8,
  
  /* All CAMELLIA-256 suites */
  TLS_RSA_WITH_CAMELLIA_256_GCM_SHA384,
  TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256,
  TLS_RSA_WITH_CAMELLIA_256_CBC_SHA,
  TLS_ECDH_RSA_WITH_CAMELLIA_256_GCM_SHA384,
  TLS_ECDH_RSA_WITH_CAMELLIA_256_CBC_SHA384,
  TLS_ECDH_ECDSA_WITH_CAMELLIA_256_GCM_SHA384,
  TLS_ECDH_ECDSA_WITH_CAMELLIA_256_CBC_SHA384,
  
  /* All AES-128 suites */
  TLS_RSA_WITH_AES_128_GCM_SHA256,
  TLS_RSA_WITH_AES_128_CCM,
  TLS_RSA_WITH_AES_128_CBC_SHA256,
  TLS_RSA_WITH_AES_128_CBC_SHA,
  TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256,
  TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256,
  TLS_ECDH_RSA_WITH_AES_128_CBC_SHA,
  TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256,
  TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256,
  TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA,
  TLS_RSA_WITH_AES_128_CCM_8,
  
  /* All CAMELLIA-128 suites */
  TLS_RSA_WITH_CAMELLIA_128_GCM_SHA256,
  TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256,
  TLS_RSA_WITH_CAMELLIA_128_CBC_SHA,
  TLS_ECDH_RSA_WITH_CAMELLIA_128_GCM_SHA256,
  TLS_ECDH_RSA_WITH_CAMELLIA_128_CBC_SHA256,
  TLS_ECDH_ECDSA_WITH_CAMELLIA_128_GCM_SHA256,
  TLS_ECDH_ECDSA_WITH_CAMELLIA_128_CBC_SHA256,
  
  /* All remaining >= 128-bit suites */
  TLS_RSA_WITH_3DES_EDE_CBC_SHA,
  TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA,
  TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA,
  
  /* The RSA PSK suites */
  TLS_RSA_PSK_WITH_AES_256_GCM_SHA384,
  TLS_RSA_PSK_WITH_AES_256_CBC_SHA384,
  TLS_RSA_PSK_WITH_AES_256_CBC_SHA,
  TLS_RSA_PSK_WITH_CAMELLIA_256_GCM_SHA384,
  TLS_RSA_PSK_WITH_CAMELLIA_256_CBC_SHA384,
  
  TLS_RSA_PSK_WITH_AES_128_GCM_SHA256,
  TLS_RSA_PSK_WITH_AES_128_CBC_SHA256,
  TLS_RSA_PSK_WITH_AES_128_CBC_SHA,
  TLS_RSA_PSK_WITH_CAMELLIA_128_GCM_SHA256,
  TLS_RSA_PSK_WITH_CAMELLIA_128_CBC_SHA256,
  
  TLS_RSA_PSK_WITH_3DES_EDE_CBC_SHA,
  
  /* The PSK suites */
  TLS_PSK_WITH_AES_256_GCM_SHA384,
  TLS_PSK_WITH_AES_256_CCM,
  TLS_PSK_WITH_AES_256_CBC_SHA384,
  TLS_PSK_WITH_AES_256_CBC_SHA,
  TLS_PSK_WITH_CAMELLIA_256_GCM_SHA384,
  TLS_PSK_WITH_CAMELLIA_256_CBC_SHA384,
  TLS_PSK_WITH_AES_256_CCM_8,
  
  TLS_PSK_WITH_AES_128_GCM_SHA256,
  TLS_PSK_WITH_AES_128_CCM,
  TLS_PSK_WITH_AES_128_CBC_SHA256,
  TLS_PSK_WITH_AES_128_CBC_SHA,
  TLS_PSK_WITH_CAMELLIA_128_GCM_SHA256,
  TLS_PSK_WITH_CAMELLIA_128_CBC_SHA256,
  TLS_PSK_WITH_AES_128_CCM_8,
  
  TLS_PSK_WITH_3DES_EDE_CBC_SHA,
  
  /* RC4 suites */
  TLS_ECDHE_ECDSA_WITH_RC4_128_SHA,
  TLS_ECDHE_RSA_WITH_RC4_128_SHA,
  TLS_ECDHE_PSK_WITH_RC4_128_SHA,
  TLS_DHE_PSK_WITH_RC4_128_SHA,
  TLS_RSA_WITH_RC4_128_SHA,
  TLS_RSA_WITH_RC4_128_MD5,
  TLS_ECDH_RSA_WITH_RC4_128_SHA,
  TLS_ECDH_ECDSA_WITH_RC4_128_SHA,
  TLS_RSA_PSK_WITH_RC4_128_SHA,
  TLS_PSK_WITH_RC4_128_SHA,
  
  /* Weak suites */
  //TLS_DHE_RSA_WITH_DES_CBC_SHA,
  TLS_RSA_WITH_DES_CBC_SHA,
  
  /* NULL suites */
  //TLS_ECDHE_ECDSA_WITH_NULL_SHA,
  //TLS_ECDHE_RSA_WITH_NULL_SHA,
  //TLS_ECDHE_PSK_WITH_NULL_SHA384,
  //TLS_ECDHE_PSK_WITH_NULL_SHA256,
  //TLS_ECDHE_PSK_WITH_NULL_SHA,
  //TLS_DHE_PSK_WITH_NULL_SHA384,
  //TLS_DHE_PSK_WITH_NULL_SHA256,
  //TLS_DHE_PSK_WITH_NULL_SHA,
  
  //TLS_RSA_WITH_NULL_SHA256,
  //TLS_RSA_WITH_NULL_SHA,
  //TLS_RSA_WITH_NULL_MD5,
  //TLS_ECDH_RSA_WITH_NULL_SHA,
  //TLS_ECDH_ECDSA_WITH_NULL_SHA,
  //TLS_RSA_PSK_WITH_NULL_SHA384,
  //TLS_RSA_PSK_WITH_NULL_SHA256,
  //TLS_RSA_PSK_WITH_NULL_SHA,
  //TLS_PSK_WITH_NULL_SHA384,
  //TLS_PSK_WITH_NULL_SHA256,
  //TLS_PSK_WITH_NULL_SHA,

  0
};