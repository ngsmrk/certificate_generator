module CertificateGenerator

  class CACertificateGenerator < Base

    def generate_ca_cert (cname, output_dir)

      cert, key = generate_core_cert cname, 0
      cert.issuer  = cert.subject

      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate  = cert

      cert.extensions = [
        ef.create_extension("basicConstraints","CA:TRUE"),
        ef.create_extension("keyUsage","Certificate Sign, CRL Sign"),
      ]

      cert.sign key, OpenSSL::Digest::SHA1.new

      save_cert_and_key cert, key, output_dir

      return cert, key

    end
    
  end

end