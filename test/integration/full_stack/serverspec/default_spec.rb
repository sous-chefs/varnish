# Encoding: utf-8

require_relative 'spec_helper'

describe port(80) do
  it 'varnish listens on the correct port' do
    expect(subject).to be_listening.on('0.0.0.0').with('tcp')
  end
end

describe port(8080) do
  it 'nginx listens on the correct port' do
    expect(subject).to be_listening.on('0.0.0.0').with('tcp')
  end
end

describe command('curl -v localhost') do
  it 'exits zero' do
    expect(subject.exit_status).to eq 0
  end
  it 'returns the correct file' do
    expect(subject.stdout).to match(/Hello World!/)
  end
end

describe command('sleep 2; curl -v localhost') do
  it 'exits zero' do
    expect(subject.exit_status).to eq 0
  end
  it 'returns the correct file' do
    expect(subject.stdout).to match(/Hello World!/)
  end
  it 'the file is cached in varnish' do
    expect(subject.stderr).to_not match(/Age: 0\s*/)
    expect(subject.stderr).to match(/Age: [0-9]+/)
  end
end
