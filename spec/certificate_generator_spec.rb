require 'rspec/autorun'
require 'certificate_generator'
require 'date'

describe CertificateGenerator::CACertificateGenerator do
  
  context 'when generating a Certificate Authority certificate' do
    
    before :each do
      
      generator = CertificateGenerator::CACertificateGenerator.new
      
      @cname = "CA"
      output_path = '/tmp'
      @ca_cert, @key = generator.generate_ca_cert @cname, output_path
      
    end
    
    it 'the subject is set correctly' do
      expected_subject = "/C=GB/ST=London/L=London/O=XBridge Ltd/OU=Tech/CN=#{@cname}/emailAddress=systems@xbridge.com"
      @ca_cert.subject.to_s.should == expected_subject
    end
    
    it 'the issuer is set correctly' do
      expected_issuer = "/C=GB/ST=London/L=London/O=XBridge Ltd/OU=Tech/CN=#{@cname}/emailAddress=systems@xbridge.com"
      @ca_cert.issuer.to_s.should == expected_issuer
    end   
    
    it 'the serial is set correctly' do
      @ca_cert.serial.should == 0
    end
    
    it 'the version is set correctly' do
      @ca_cert.version.should == 2
    end    
    
    it 'the expiry date is set correctly' do
      @ca_cert.not_after.should < (DateTime.now + 365).to_time      
      @ca_cert.not_after.should > (DateTime.now + 364).to_time
    end
    
    it 'the start date is set correctly' do
      @ca_cert.not_before.should < Time.now      
    end
    
    it 'the extensions are set correctly' do
      @ca_cert.extensions.to_s.should == "[basicConstraints = CA:TRUE, keyUsage = Certificate Sign, CRL Sign]" 
    end
    
  end
  
end