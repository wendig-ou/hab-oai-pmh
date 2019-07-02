describe 'HAB OAI-PMH Interface' do
  before :each do
    @client = HTTPClient.new
    @base = 'http://localhost:8080/exist/apps/hab-oai-pmh'
  end

  it 'should GET GetRecord' do
    request('GET', '/oai-pmh',
      verb: 'GetRecord',
      identifier: 'HAB_mss_285-novi_tei-msDesc',
      metadataPrefix: 'oai_tei'
    )
    expect_success
    expect_no_oai_errors
    expect_verb 'GetRecord'
    expect_result 'HAB_mss_285-novi_tei-msDesc'
  end

  it 'should GET GetRecord (non-existing record)' do
    request('GET', '/oai-pmh',
      verb: 'GetRecord',
      identifier: 'no-exist',
      metadataPrefix: 'oai_tei'
    )
    expect_success
    expect_oai_error('idDoesNotExist')
  end

  it 'should GET Identify' do
    request('GET', '/oai-pmh', 
      verb: 'Identify'
    )
    expect_success
    expect_no_oai_errors
    expect_verb 'Identify'
  end

  it 'should GET ListIdentifiers' do
    request('GET', '/oai-pmh', verb: 'ListIdentifiers')
    expect_success
    expect_oai_error('badArgument')
    
    request('GET', '/oai-pmh',
      verb: 'ListIdentifiers',
      metadataPrefix: 'oai_tei'
    )
    expect_success
    expect_no_oai_errors
    expect(xml.css('header').count).to eq(50)
  end

  it 'should GET ListIdentifiers with filtering' do
    params = {
      verb: 'ListIdentifiers',
      metadataPrefix: 'oai_tei'
    }

    request('GET', '/oai-pmh', params.merge(from: '2019-06-25T00:00:00Z'))
    expect(xml.css('header').count).to eq(3)

    request('GET', '/oai-pmh', params.merge(until: '2019-06-25T00:00:00Z'))
    expect(xml.css('header').count).to eq(50)
    token = xml.css('resumptionToken')
    total = token.attr('completeListSize').text.to_i
    expect(total).to eq(10318)

    request('GET', '/oai-pmh', params.merge(set: 'MusikHandschriften'))
    expect(xml.css('header').count).to eq(50)
    token = xml.css('resumptionToken')
    total = token.attr('completeListSize').text.to_i
    expect(total).to eq(489)
  end

  it 'should GET ListIdentifiers and provide resumptionTokens' do
    params = {
      verb: 'ListIdentifiers',
      metadataPrefix: 'oai_tei'
    }

    request('GET', '/oai-pmh', params)
    token = xml.css('resumptionToken') 
    total = token.attr('completeListSize').text.to_i
    expect(total).to be > 50

    ids = []

    loop do
      token = xml.css('resumptionToken')
      ids += xml.css('header identifier').map{|i| i.text}

      break if token.text.match(/^\s*$/)

      request('GET', '/oai-pmh', params.merge(resumptionToken: token.text))
    end

    expect(ids.size).to eq(total)
  end

  it 'should GET ListMetadataFormats' do
    request 'GET', '/oai-pmh', verb: 'ListMetadataFormats'
    expect_success
    expect_no_oai_errors
    prefixes = xml.css('metadataPrefix').map{|e| e.text}
    expect(prefixes).to eq(['oai_dc', 'oai_tei'])
  end

  it 'should GET ListRecords' do
    request('GET', '/oai-pmh', verb: 'ListRecords')
    expect_success
    expect_oai_error('badArgument')
    
    request('GET', '/oai-pmh',
      verb: 'ListRecords',
      metadataPrefix: 'oai_tei'
    )
    expect_success
    expect_no_oai_errors
    expect(xml.css('header').count).to eq(50)
    expect(xml.css('metadata').count).to eq(50)
  end

  it 'should GET ListSets' do
    request 'GET', '/oai-pmh', verb: 'ListSets'
    expect_success
    expect_no_oai_errors
  end

  it 'should POST GetRecord (application/x-www-form-urlencoded)' do
    request('POST', '/oai-pmh', {}, {},
      verb: 'GetRecord',
      identifier: 'HAB_mss_285-novi_tei-msDesc',
      metadataPrefix: 'oai_tei'
    )
    expect_success
    expect_no_oai_errors
    expect_verb 'GetRecord'
    expect_result 'HAB_mss_285-novi_tei-msDesc'
  end

  def request(request_method, path, query = {}, body = nil, headers = {})
    @response = nil
    @xml = nil
    @response = @client.request(request_method, @base + path, query, headers, body)
  end

  def expect_success
    expect(@response.status).to eq(200)
  end

  def expect_404
    expect(@response.status).to eq(404)
  end

  def expect_no_oai_errors
    expect(xml.css('error[code]')).to be_empty
  end

  def expect_oai_error(code)
    errors = xml.css('error[code]')
    found = errors.each{|i| return if i.attr('code') == code}
    fail "error #{code} not returned"
  end

  def expect_verb(verb)
    expect(xml.css("OAI-PMH > #{verb}")).not_to be_empty
  end

  def expect_result(id)
    found = xml.css("header identifier").each do |i|
      return if i.text == id
    end
    fail "id #{id} not returned within rsponse"
  end

  def xml
    @xml ||= Nokogiri::XML(@response.body)
  end
end