import Vue from 'vue'
import VueRouter from 'vue-router'
import store from '@/store'

Vue.use(VueRouter)

const ifNotAuthenticated = (_to, _from, next) => {
  if (!store.getters['auth/isAuthenticated']) {
    next()
    return
  }
  next({ name: 'home' })
}

const ifAuthenticated = (_to, _from, next) => {
  if (store.getters['auth/isAuthenticated']) {
    next()
    return
  }
  next({ name: 'log_in' })
}

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('@/views/Home.vue'),
  },
  {
    path: '/about',
    name: 'about',
    component: () => import('@/views/About.vue'),
  },
  {
    path: '/log_in',
    name: 'log_in',
    component: () => import('@/views/Login.vue'),
    beforeEnter: ifNotAuthenticated,
  },
  {
    path: '/sign_up',
    name: 'sign_up',
    component: () => import('@/views/SignUp.vue'),
    beforeEnter: ifNotAuthenticated,
  },
  {
    path: '/projects',
    name: 'projects',
    component: () => import('@/views/Projects.vue'),
    beforeEnter: ifAuthenticated,
  },
  {
    path: '/project/create',
    name: 'create_project',
    component: () => import('@/views/CreateProject.vue'),
    beforeEnter: ifAuthenticated,
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
