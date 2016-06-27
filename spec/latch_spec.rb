require 'spec_helper'

describe Latch do
  let(:io) {
    StringIO.new(<<-BYC)
# load 10 into r01
01 0002 0A
# add r01 and r02
0B 0001 0001 0002
# load 34 into r02
01 0002 22
# test if r01 > r02
1F 0001 0002
# jump if false
2A 7
# load "older" into r03
01 0003 "older
# jump to end
29 0C
# test if r01 = r02
1B 0001 0002
# jump if false
2A 0B
# load "same" into r03
01 0003 "same
# jump to end
29 0C
# else - load "younger" into r03
01 0003 "younger
# call print with r03
26 print 0003 1
# return value in r01
28 0001

# load 24 into r01
01 0001 18
# call print with r01
26 print 0001 1
# create function
30 0002
# move r01 into r03
04 0003 0001
# call function in r01
27 0002 1
# move rval into r01
06 0001
# call print with r01
26 print 0001 1
# return value in r01
28 0001
    BYC
  }

  it 'has a version number' do
    expect(Latch::VERSION).not_to be nil
  end

  it 'runs example bytecode' do
    fake_stdout = StringIO.new

    bytecode = Latch.read_bytecode(io)
    Latch::Builtin.redirect(fake_stdout)

    # run at starting position
    Latch::Vm.new.run(bytecode, 14)

    output = fake_stdout.string.split("\n")

    expect(output[0]).to eq('24')
    expect(output[1]).to eq('"same"')
    expect(output[2]).to eq('34')
  end
end
