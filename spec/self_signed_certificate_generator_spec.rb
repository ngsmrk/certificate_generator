require 'rspec/autorun'
require 'certificate_generator'
require 'date'

describe CertificateGenerator::SelfSignedCertificateGenerator do
  
  context 'when generating a self-signed server certificate' do
    
    before :each do
      
      output_path = '/tmp'
      
      @ca_cname = "CA"
      ca_cert, ca_key = CertificateGenerator::CACertificateGenerator.new.generate_ca_cert @ca_cname, output_path      
      
      @cname = "my.server"
      output_path = '/tmp'
      @cert, @key = CertificateGenerator::SelfSignedCertificateGenerator.new.generate_server_cert @cname, output_path, ca_cert, ca_key
      
    end
    
    it 'the subject is set correctly' do
      expected_subject = "/C=GB/ST=London/L=London/O=Acme Inc/OU=Tech/CN=#{@cname}/emailAddress=ngsmrk@gmail.com"
      @cert.subject.to_s.should == expected_subject
    end
    
    it 'the issuer is set correctly' do
      expected_issuer = "/C=GB/ST=London/L=London/O=Acme Inc/OU=Tech/CN=#{@ca_cname}/emailAddress=ngsmrk@gmail.com"
      @cert.issuer.to_s.should == expected_issuer
    end   
    
    it 'the serial is set correctly' do
      @cert.serial.should_not be_nil 
    end
    
    it 'the version is set correctly' do
      @cert.version.should == 2
    end    
    
    it 'the expiry date is set correctly' do
      @cert.not_after.should < (DateTime.now + 365).to_time      
      @cert.not_after.should > (DateTime.now + 364).to_time
    end
    
    it 'the start date is set correctly' do
      @cert.not_before.should < Time.now      
    end
    
    it 'the extensions are set correctly' do
      @cert.extensions.to_s.should == "[basicConstraints = CA:FALSE, keyUsage = Key Encipherment, extendedKeyUsage = TLS Web Server Authentication]"
    end
    
  end

  context 'when generating a self-signed client certificate' do

     before :each do

       output_path = '/tmp'

       @ca_cname = "CA"
       ca_cert, ca_key = CertificateGenerator::CACertificateGenerator.new.generate_ca_cert @ca_cname, output_path

       @cname = "my.server"
       output_path = '/tmp'
       @cert, @key = CertificateGenerator::SelfSignedCertificateGenerator.new.generate_client_cert @cname, output_path, ca_cert, ca_key

     end

     it 'the subject is set correctly' do
       expected_subject = "/C=GB/ST=London/L=London/O=Acme Inc/OU=Tech/CN=#{@cname}/emailAddress=ngsmrk@gmail.com"
       @cert.subject.to_s.should == expected_subject
     end

     it 'the issuer is set correctly' do
       expected_issuer = "/C=GB/ST=London/L=London/O=Acme Inc/OU=Tech/CN=#{@ca_cname}/emailAddress=ngsmrk@gmail.com"
       @cert.issuer.to_s.should == expected_issuer
     end

     it 'the serial is set correctly' do
       @cert.serial.should_not be_nil
     end

     it 'the version is set correctly' do
       @cert.version.should == 2
     end

     it 'the expiry date is set correctly' do
       @cert.not_after.should < (DateTime.now + 365).to_time
       @cert.not_after.should > (DateTime.now + 364).to_time
     end

     it 'the start date is set correctly' do
       @cert.not_before.should < Time.now
     end

     it 'the extensions are set correctly' do
       @cert.extensions.to_s.should == "[basicConstraints = CA:FALSE, keyUsage = Digital Signature, extendedKeyUsage = TLS Web Client Authentication]"
     end

   end
   
 end