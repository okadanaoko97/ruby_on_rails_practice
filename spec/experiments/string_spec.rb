require "spec_helper"

describe String do
  describe "#<<" do
    example "文字の追加" do
    # it "appends a character" do
      s = "ABC"
      s << "D"
      expect(s.size).to eq(4)
    end

    example "nilの追加", :exception do
    # example "nilの追加" do
    # xexample "nilの追加" do
      # pending("調査中")
      s = "ABC"
      # s << nil
      # expect(s.size).not_to eq(4)
      expect{ s << nil }.to raise_error(TypeError)
    end
  end
end
