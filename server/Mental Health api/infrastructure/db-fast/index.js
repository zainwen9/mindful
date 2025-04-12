const Redis = require('redis');

const redis = Redis.createClient({
    socket: {
        host: 'redis-18233.c8.us-east-1-3.ec2.redns.redis-cloud.com',
        port: 18233,
    },
    password: 'RORzhkVqmVnA1YKOo1jGdrrJrU0FiQUK'
});

(async () => {
    await redis.connect(); 
})();

module.exports = redis;
