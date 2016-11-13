part of dartz;

abstract class Foldable<F> {
  // def foldMap[A, B: Monoid](fa: Option[A], f: A => B): B
  /*=B*/ foldMap/*<B>*/(Monoid/*<B>*/ bMonoid, F fa, /*=B*/ f(a));

  /*=B*/ foldRight/*<B>*/(F fa, /*=B*/ z, /*=B*/ f(a, /*=B*/ previous)) => foldMap/*<Endo<B>>*/(endoMi(), fa, curry2(f))(z);

  /*=B*/ foldRightWithIndex/*<B>*/(F fa, /*=B*/ z, /*=B*/ f(int i, a, /*=B*/ previous)) => foldRight(fa, tuple2(z, length(fa)-1), (a, /*=Tuple2<B, int>*/ t) => tuple2(f(t.value2, a, t.value1), t.value2-1)).value1;

  /*=B*/ foldLeft/*<B>*/(F fa, /*=B*/ z, /*=B*/ f(/*=B*/ previous, a)) => foldMap/*<Endo<B>>*/(dualEndoMi(), fa, curry2(flip(f)))(z);

  /*=B*/ foldLeftWithIndex/*<B>*/(F fa, /*=B*/ z, /*=B*/ f(/*=B*/ previous, int i, a)) => foldLeft(fa, tuple2(z, 0), (/*=Tuple2<B, int>*/ t, a) => tuple2(f(t.value1, t.value2, a), t.value2+1)).value1;

  Option/*<A>*/ foldMapO/*<A>*/(Semigroup/*<A>*/ si, F fa, /*=A*/ f(a)) => foldMap(new OptionMonoid/*<A>*/(si), fa, composeF(some, f));

  /*=A*/ concatenate/*<A>*/(Monoid/*<A>*/ mi, F fa) => foldMap(mi, fa, id);

  Option/*<A>*/ concatenateO/*<A>*/(Semigroup/*<A>*/ si, F fa) => foldMapO(si, fa, id);

  int length(F fa) => foldLeft(fa, 0, (a, _) => a+1);

  bool any(F fa, bool f(a)) => foldMap(BoolOrMi, fa, f);

  bool all(F fa, bool f(a)) => foldMap(BoolAndMi, fa, f);

  Option/*<A>*/ minimum/*<A>*/(Order/*<A>*/ oa, F fa) => concatenateO(new MinSemigroup(oa), fa);

  Option/*<A>*/ maximum/*<A>*/(Order/*<A>*/ oa, F fa) => concatenateO(new MaxSemigroup(oa), fa);

  /*=A*/ intercalate/*<A>*/(Monoid/*<A>*/ mi, F fa, /*=A*/ a) => foldRight/*<Option<A>>*/(fa, none(), (/*=A*/ ca, oa) => some(mi.append(ca, oa.fold(mi.zero, mi.appendC(a))))) | mi.zero();

  /*=G*/ collapse/*<G>*/(ApplicativePlus/*<G>*/ ap, F fa) => foldLeft(fa, ap.empty(), (p, a) => ap.plus(p, ap.pure(a)));

  /*=G*/ foldLeftM/*<G>*/(Monad/*<G>*/ m, F fa, z, /*=G*/ f(previous, a)) => foldRight/*<Function1<dynamic, G>>*/(fa, m.pure, (a, b) => (w) => m.bind(f(w, a), b))(z);

  /*=G*/ foldRightM/*<G>*/(Monad/*<G>*/ m, F fa, z, /*=G*/ f(a, previous)) => foldLeft/*<Function1<dynamic, G>>*/(fa, m.pure, (b, a) => (w) => m.bind(f(a, w), b))(z);

  /*=G*/ foldMapM/*<G, B>*/(Monad/*<G>*/ m, Monoid/*<B>*/ bMonoid, F fa, /*=G*/ f(a)) => foldMap(monoid(() => m.pure(bMonoid.zero()), m.lift2(bMonoid.append)), fa, f);
}

abstract class FoldableOps<F, A> {
  /*=B*/ foldMap/*<B>*/(Monoid/*<B>*/ bMonoid, /*=B*/ f(A a));

  /*=B*/ foldRight/*<B>*/(/*=B*/ z, /*=B*/ f(A a, /*=B*/ previous)) => foldMap/*<Endo<B>>*/(endoMi(), curry2(f))(z);

  /*=B*/ foldRightWithIndex/*<B>*/(/*=B*/ z, /*=B*/ f(int i, A a, /*=B*/ previous)) => foldRight/*<Tuple2<B, int>>*/(tuple2(z, length()-1), (a, t) => tuple2(f(t.value2, a, t.value1), t.value2-1)).value1;

  /*=B*/ foldLeft/*<B>*/(/*=B*/ z, /*=B*/ f(/*=B*/ previous, A a)) => foldMap/*<Endo<B>>*/(dualEndoMi(), curry2(flip(f)))(z);

  /*=B*/ foldLeftWithIndex/*<B>*/(/*=B*/ z, /*=B*/ f(/*=B*/ previous, int i, A a)) => foldLeft/*<Tuple2<B, int>>*/(tuple2(z, 0), (t, a) => tuple2(f(t.value1, t.value2, a), t.value2+1)).value1;

  Option/*<B>*/ foldMapO/*<B>*/(Semigroup/*<B>*/ si, /*=B*/ f(A a)) => foldMap/*<Option<B>>*/(new OptionMonoid/*<B>*/(si), composeF(some, f));

  A concatenate(Monoid<A> mi) => foldMap(mi, id);

  Option<A> concatenateO(Semigroup<A> si) => foldMapO(si, id);

  int length() => foldLeft(0, (a, b) => a+1);

  bool any(bool f(A a)) => foldMap(BoolOrMi, f);

  bool all(bool f(A a)) => foldMap(BoolAndMi, f);

  Option<A> minimum(Order<A> oa) => concatenateO(new MinSemigroup<A>(oa));

  Option<A> maximum(Order<A> oa) => concatenateO(new MaxSemigroup<A>(oa));

  A intercalate(Monoid<A> mi, A a) => foldRight(none/*<A>*/(), (A ca, Option oa) => some(mi.append(ca, oa.fold(mi.zero, mi.appendC(a))))) | mi.zero();

  /*=G*/ collapse/*<G>*/(ApplicativePlus/*<G>*/ ap) => foldLeft(ap.empty(), (p, a) => ap.plus(p, ap.pure(a)));

  /*=G*/ foldLeftM/*<G>*/(Monad/*<G>*/ m, z, /*=G*/ f(previous, A a)) => foldRight/*<Function1<dynamic, G>>*/(m.pure, (A a, b) => (w) => m.bind(f(w, a), b))(z);

  /*=G*/ foldRightM/*<G>*/(Monad/*<G>*/ m, z, /*=G*/ f(A a, previous)) => foldLeft/*<Function1<dynamic, G>>*/(m.pure, (b, A a) => (w) => m.bind(f(a, w), b))(z);

  /*=G*/ foldMapM/*<G, B>*/(Monad/*<G>*/ m, Monoid/*<B>*/ bMonoid, /*=G*/ f(A a)) => foldMap(monoid(() => m.pure(bMonoid.zero()), m.lift2(bMonoid.append)), f);
}

class FoldableOpsFoldable<F extends FoldableOps> extends Foldable<F> {
  @override /*=B*/ foldMap/*<B>*/(Monoid/*<B>*/ bMonoid, F fa, /*=B*/ f(a)) => fa.foldMap(bMonoid, f);
  @override /*=B*/ foldRight/*<B>*/(F fa, /*=B*/ z, /*=B*/ f(a, /*=B*/ previous)) => fa.foldRight(z, f);
  @override /*=B*/ foldLeft/*<B>*/(F fa, /*=B*/ z, /*=B*/ f(/*=B*/ previous, a)) => fa.foldLeft(z, f);
}
