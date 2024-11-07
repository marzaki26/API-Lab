function variables() {
    var config = {
      baseUrl: 'http://localhost:8500/',
      clientId: 'DPE-QE'                         
    };

    // Token
    karate.configure('headers', { 'Client-Id': config.clientId });
    var result = karate.callSingle('classpath:create_token.feature', { key: 'quality-engineering' });
    config.token = result.token;

    return config;
}