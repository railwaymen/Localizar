import axios from 'axios'
import router from '@/router'
import store from '@/store'
import { storageKey } from './storageKey'
import { coreBackendHost } from '@/config'

const initClient = () => {
  const getBaseURL = () => [coreBackendHost || '', 'v1'].join("/")
  const getToken = () => localStorage.getItem(storageKey.userToken)

  const client = axios.create()

  client.interceptors.request.use(
    (requestConfig) => {
      const options = {
        baseURL: getBaseURL(),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Token': getToken(),
        }
      }
      return { ...requestConfig, ...options }
    },
    (requestError) => {
      return Promise.reject(requestError)
    },
  )

  client.interceptors.response.use(
    response => response,
    (error) => {
      switch (error.response.status) {
        case 401:
          store.dispatch('auth/AUTH_LOGOUT')
          router.push('/log_in')
          break
        default:
          break
      }
      return Promise.reject(error)
    }
  )

  return client
}

class NetworkingLayer {

  constructor() {
    this.client = initClient()
  }

  get(url, conf = {}) {
    return this.client.get(url, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error))
  }

  delete(url, conf = {}) {
    return this.client.delete(url, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error))
  }

  head(url, conf = {}) {
    return this.client.head(url, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error))
  }

  options(url, conf = {}) {
    return this.client.options(url, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error))
  }

  post(url, data = {}, conf = {}) {
    return this.client.post(url, data, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error))
  }

  put(url, data = {}, conf = {}) {
    return this.client.put(url, data, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error))
  }

  patch(url, data = {}, conf = {}) {
    return this.client.patch(url, data, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error))
  }

  getToken() {
    return localStorage.getItem(storageKey.userToken)
  }

  setToken(token) {
    localStorage.setItem(storageKey.userToken, token)
    this.client.defaults.headers.common['Token'] = token
  }

  removeToken() {
    localStorage.removeItem(storageKey.userToken)
    delete this.client.defaults.headers.common['Token']
  }
}

const networking = new NetworkingLayer()
export default networking
