require 'openssl'

module CertificateGenerator
  
  class Base
    
    def generate_core_cert (cname, serial)

      key = OpenSSL::PKey::RSA.new(2048)

      cert = OpenSSL::X509::Certificate.new
      subject = "/C=GB/ST=London/L=London/O=XBridge Ltd/OU=Tech/CN=#{cname}/emailAddress=systems@xbridge.com"
      parsed_subject = OpenSSL::X509::Name.parse(subject)
      cert.subject = parsed_subject

      cert.not_before = Time.now
      cert.not_after = Time.now + (3600*24*365) # add a year
      cert.public_key = key.public_key
      cert.serial = serial
      cert.version = 2

      return cert, key

    end   
      
    def save_cert_and_key (cert, key, output_dir)
    
      FileUtils.mkdir_p("#{output_dir}")
      File.open("/#{output_dir}/cert.pem", "w") { |f| f.write(cert.to_pem) }
      File.open("/#{output_dir}/key.pem", "w") { |f| f.write(key.to_pem) }
    
    end     
    
  end
  
end