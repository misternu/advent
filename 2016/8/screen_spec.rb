require_relative 'screen'

describe Screen do
  let(:screen) { Screen.new({width:4, height:3}) }

  describe '#rect' do
    it 'draws a rectangle in the top left corner of the screen' do
      expect{ screen.rect(3,2) }.to change { screen.to_s }
        .from("....\n....\n....").to("###.\n###.\n....")
    end
    it 'can draw 1x1' do
      screen.rect(1,1)
      expect(screen.to_s).to eq "#...\n....\n...."
    end
  end

  describe '#rotate_row' do
    it 'rotates a given row by a given distance' do
      screen.rect(3,2)
      expect{ screen.rotate_row(0,1) }.to change { screen.to_s }
        .from("###.\n###.\n....").to(".###\n###.\n....")
      expect{ screen.rotate_row(1,2) }.to change { screen.to_s }
        .from(".###\n###.\n....").to(".###\n#.##\n....")
    end
  end

  describe '#rotate_col' do
    it 'rotates a given col by a given distance' do
      screen.rect(3,2)
      expect{ screen.rotate_col(0,1) }.to change { screen.to_s }
        .from("###.\n###.\n....").to(".##.\n###.\n#...")
      expect{ screen.rotate_col(1,2) }.to change { screen.to_s }
        .from(".##.\n###.\n#...").to(".##.\n#.#.\n##..")
    end
  end
end