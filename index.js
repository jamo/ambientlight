import exec from 'execa'

module.exports = exports.default = function ambient () {
  const out = exec.sync(`${__dirname}/ambientlight`).stdout
  return Number(out)
}
