require 'lib/dm-utf8.rb'
describe "utf8 filter" do

  before do
    class Item
      include DataMapper::Resource
      
      property :id, Serial
      
      property :text, String
    end

    DataMapper.setup(:default, 'sqlite3::memory:')
    DataMapper.auto_migrate!(:default)
  end

  it 'should pass through legal utf8 character' do
    DmUtf8::Filter.filter("κόσμε").should == "\316\272\341\275\271\317\203\316\274\316\265"
  end

  it 'should filter out illegal utf8 character' do
    DmUtf8::Filter.filter("\300 \301 \302 \303 \304 \305 \306 \307 \310 \311 \312 \313 \314 \315 \316 \317 ").should == "                "
                                 #1234567812345678
  end

  if Object.constants.member? "Oniguruma"
    it 'should filter out control sequences' do
      DmUtf8::Filter.filter("\207").should == ""
    end
  end

  it 'should filter attributes before setting them' do
    Item.new(:text => "\300 \301 \302 \303 ").text.should == "    "
    i = Item.create(:text => "\300 \301 \302 \303 ")
    i.text.should == "    "
    i.text = "\300 \301 \302 \303 \304 \305 \306 \307 \310 \311 \312 \313 \314 \315 \316 \317 "
    i.text.should == "                "
    i.update_attributes(:text => "\300 \301 \302 \303 \304 \305 \306 \307 ")
    i.text.should == "        "
  end
  
end
