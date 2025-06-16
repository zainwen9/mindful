//const Redis = require('redis');
//
//const redis = Redis.createClient({
//    socket: {
//        host: 'redis-18233.c8.us-east-1-3.ec2.redns.redis-cloud.com',
//        port: 18233,
//    },
//    password: 'RORzhkVqmVnA1YKOo1jGdrrJrU0FiQUK'
//});
//
//(async () => {
//    await redis.connect();
//})();
//
//module.exports = redis;
const Redis = require('redis');

const redis = Redis.createClient({
    socket: {
        host: 'redis-17241.c100.us-east-1-4.ec2.redns.redis-cloud.com',
        port: 17241,
    },
    password: 'wxHffgZTK28qhfc9Vxca7OdQ4o8CCXsz'
});

(async () => {
    await redis.connect();
})();

module.exports = redis;