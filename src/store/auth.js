import { apiClient } from '../modules/apiClient'

export const AUTH_REQUEST = 'AUTH_REQUEST'
export const AUTH_LOGOUT = 'AUTH_LOGOUT'
export const AUTH_SUCCESS = 'AUTH_SUCCESS'
export const AUTH_ERROR = 'AUTH_ERROR'

export const USER_REQUEST = 'USER_REQUEST'

export const AuthModule = {
    state: {
        token: localStorage.getItem('user-token') || '',
        status: '',
    },
    getters: {
        isAuthenticated: state => !!state.token,
        authStatus: state => state.status,
    },
    actions: {
        [AUTH_REQUEST]: ({ commit, dispatch }, user) => {
            return new Promise((resolve, reject) => {
                commit(AUTH_REQUEST)
                apiClient.post('/v1/sessions', { data: user })
                    .then(response => {
                        const token = response.data.token
                        apiClient.setToken(token)
                        commit(AUTH_SUCCESS, token)
                        dispatch(USER_REQUEST)
                        resolve(response)
                    })
                    .catch(error => {
                        commit(AUTH_ERROR, error)
                        apiClient.removeToken
                        reject(error)
                    })
            })
        },
        [AUTH_LOGOUT]: ({ commit }) => {
            return new Promise((resolve) => {
                commit(AUTH_LOGOUT)
                apiClient.removeToken()
                resolve()
            })
        }
    },
    mutations: {
        [AUTH_REQUEST]: (state) => {
            state.status = 'loading'
        },
        [AUTH_SUCCESS]: (state, token) => {
            state.status = 'success'
            state.token = token
        },
        [AUTH_ERROR]: (state) => {
            state.status = 'error'
        },
    }
}
