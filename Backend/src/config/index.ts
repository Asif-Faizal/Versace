import devConfig from './development/config';
import prodConfig from './production/config';

const env = process.env.NODE_ENV || 'development';
const config = env === 'production' ? prodConfig : devConfig;

export default config; 