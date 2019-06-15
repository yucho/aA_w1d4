#!/bin/sh
# Modify git commit history to display message in green squares on GitHub

add_commits() {
  num_required=$(expr $1 + $2 - $(git rev-list --all --count))
  if [ $num_required -lt 1 ]; then unset num_required; fi
  for i in $(seq $num_required); do
    echo -n "hello " >> diff.txt
    git add . && git commit -m "Add green square"
  done
}

set_pos() {
  pos_count=$(expr $pos_count + 0$1)
}

h() {
  for i in $(seq 5); do draw 1; done
  draw 5; draw 7; set_pos 4
  for i in $(seq 5); do draw 1; done; set_pos 9
}

e() {
  for i in $(seq 5); do draw 1; done
  for i in $(seq 3); do
    set_pos 1; for i in $(seq 3); do draw 2; done
  done; set_pos 9;
}

l() {
  for i in $(seq 5); do draw 1; done
  for i in $(seq 3); do draw 7; done; set_pos 9
}

o() {
  set_pos 1;
  for i in $(seq 3); do draw 1; done
  draw 4; draw 4; draw 3; draw 4; set_pos 3
  for i in $(seq 3); do draw 1; done; set_pos 10
}

draw() {
  set_pos $1
  pos_square="$(date $start_pos -v+${pos_count}d)"
  for i in $(seq $darkness); do
    GIT_COMMITTER_DATE="$pos_square" git commit --amend --no-edit --date="$pos_square"
    git rebase --continue
  done
}

draw_hello() {
  echo $':%s/pick/e/g\n:wq\n' | GIT_EDITOR=vi git rebase -i HEAD~$total_squares
  start_pos="-v2018y -v7m -v15d"
  pos_count=0
  h; e; l; l; o;
}

h=12; e=14; l=8; o=10; darkness=10
offset_commits=7
total_squares=$(expr \( $h + $e + $l + $l + $o \) \* $darkness )
add_commits $offset_commits $total_squares
draw_hello
