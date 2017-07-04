const gulp = require('gulp')
const run = require('gulp-run')

const paths = ['contracts/*.sol', 'test/*.js', 'test/*.sol', 'migrations/*.js']

gulp.task('contracts', )
gulp.task('watch', () => {
  gulp.watch(paths, () => {
    console.log('running tests...')
    return run('truffle test').exec(err => {
      if (err) console.log('\n\n\n\nError: \n\n\n\n', err, '\n\n\n\n')
      else console.log('tests completed!')
    })
  })
})
