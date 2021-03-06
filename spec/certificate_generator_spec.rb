require 'rspec/autorun'
require 'certificate_generator'
require 'date'

describe CertificateGenerator::CACertificateGenerator do
  
  context 'when generating a Certificate Authority certificate' do
    
    before :each do
      
      generator = CertificateGenerator::CACertificateGenerator.new
      
      output_path = '/tmp'
      @expected_subject = "/C=GB/ST=London/L=London/O=Acme Inc/OU=Tech/CN=CA/emailAddress=ngsmrk@gmail.com"      
      @ca_cert, @key = generator.generate_ca_cert @expected_subject, output_path
      
    end
    
    it 'the subject is set correctly' do
      @ca_cert.subject.to_s.should == @expected_subject
    end
    
    it 'the issuer is set correctly' do
      @ca_cert.issuer.to_s.should == @expected_subject
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