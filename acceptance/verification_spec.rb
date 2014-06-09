require 'rexml/document'

REPORTS_DIR = File.dirname(__FILE__) + '/reports'

describe "MiniTest::Unit acceptance" do
  it "should generate two XML files" do
    File.exist?(File.join(REPORTS_DIR, 'TEST-MiniTestExampleTestOne.xml')).should == true
    File.exist?(File.join(REPORTS_DIR, 'TEST-MiniTestExampleTestTwo.xml')).should == true
  end

  it "should have one error and one failure for MiniTestExampleTestOne" do
    doc = File.open(File.join(REPORTS_DIR, 'TEST-MiniTestExampleTestOne.xml')) do |f|
      REXML::Document.new(f)
    end
    doc.root.attributes["errors"].should == "1"
    doc.root.attributes["failures"].should == "1"
    doc.root.attributes["assertions"].should == "1"
    doc.root.attributes["tests"].should == "1"
    doc.root.elements.to_a("/testsuite/testcase").size.should == 1
    doc.root.elements.to_a("/testsuite/testcase/error").size.should == 1
    doc.root.elements.to_a("/testsuite/testcase/failure").size.should == 1
    doc.root.elements.to_a("/testsuite/system-out").first.texts.inject("") do |c,e|
      c << e.value; c
    end.strip.should == "Some <![CDATA[on stdout]]>"
  end

  it "should have no errors or failures for MiniTestExampleTestTwo" do
    doc = File.open(File.join(REPORTS_DIR, 'TEST-MiniTestExampleTestTwo.xml')) do |f|
      REXML::Document.new(f)
    end
    doc.root.attributes["errors"].should == "0"
    doc.root.attributes["failures"].should == "0"
    doc.root.attributes["assertions"].should == "1"
    doc.root.attributes["tests"].should == "1"
    doc.root.elements.to_a("/testsuite/testcase").size.should == 1
    doc.root.elements.to_a("/testsuite/testcase/failure").size.should == 0
  end
end
