module CertificateGenerator

  class CACertificateGenerator < Base

    def generate_ca_cert (subject, output_dir)

      key = OpenSSL::PKey::RSA.new(2048)

      cert = OpenSSL::X509::Certificate.new
      cert.subject = cert.issuer = OpenSSL::X509::Name.parse(subject)

      cert.not_before = Time.now
      cert.not_after = Time.now + (3600*24*365) # add a year
      cert.public_key = key.public_key
      cert.serial = 0
      cert.version = 2

      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = ef.issuer_certificate = cert

      cert.extensions = [
        ef.create_extension("basicConstraints","CA:TRUE"),
        ef.create_extension("keyUsage","Certificate Sign, CRL Sign"),
      ]

      cert.sign key, OpenSSL::Digest::SHA1.new

      save_cert_and_key cert, key, output_dir, 'ca'

      return cert, key

    end
    
  end

end