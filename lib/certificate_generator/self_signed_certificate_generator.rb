module CertificateGenerator

  class SelfSignedCertificateGenerator < Base

    def generate_client_cert (cname, output_dir, ca_cert, ca_key)
      return generate_cert cname, output_dir, ca_cert, ca_key, true
    end

    def generate_server_cert (cname, output_dir, ca_cert, ca_key)
      return generate_cert cname, output_dir, ca_cert, ca_key, false
    end

    private

    def generate_cert (cname, output_dir, ca_cert, ca_key, is_client)

      cert, key = generate_core_cert cname, Random.rand(1000000)
      cert.issuer = ca_cert.subject

      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = ca_cert

      cert.extensions = is_client ? client_extensions(ef) : server_extensions(ef)

      cert.sign ca_key, OpenSSL::Digest::SHA1.new

      save_cert_and_key cert, key, output_dir

      return cert, key

    end
      
    def server_extensions ef
      [
        ef.create_extension("basicConstraints","CA:FALSE"),
        ef.create_extension("keyUsage","Key Encipherment"),
        ef.create_extension("extendedKeyUsage","1.3.6.1.5.5.7.3.1"),   #means 'TLS Web Server Authentication'
      ]
    end

    def client_extensions ef
      [
        ef.create_extension("basicConstraints","CA:FALSE"),
        ef.create_extension("keyUsage","digitalSignature"),
        ef.create_extension("extendedKeyUsage","1.3.6.1.5.5.7.3.2"),   #means 'TLS Web Client Authentication'
      ]
    end    
    
  end

end